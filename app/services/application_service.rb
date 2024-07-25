# frozen_string_literal: true

class ApplicationService
  def self.call(params: {}, context: {}, **args)
    new(params: params, context: context).call(**args)
  end

  attr_reader :result, :params, :context

  def initialize(params: {}, context: {})
    @params = params
    @context = context
    @result = Result.new
  end

  delegate :assign_data, to: :result
  delegate :assign_response, to: :result
  delegate :add_error, to: :result
  delegate :success?, to: :result
  delegate :failure?, to: :result
  alias add_errors add_error

  def step(method)
    return unless success?

    send(method)
  end

  def valid_enumerable?(object)
    return true if object.is_a?(Array)
    return true if object.is_a?(ActiveRecord::Relation)

    false
  end

  def safe_call(result)
    return result.data if result.success?

    add_error(result.errors)
  end

  def preload(*methods)
    methods.map { |method| send(method) }
  end

  def call
    raise NotImplementedError, "#call method must be implemented"
  end

  def transaction
    ActiveRecord::Base.transaction do
      yield
      raise ActiveRecord::Rollback unless success?
    end
  rescue ActiveRecord::Rollback => e
    e.message
  end

  def handle_validation_errors(model)
    return add_error(I18n.t("flash.something_wrong")) if model.changed? && model.valid?

    add_error(model.errors.full_messages).join(" , ")
  end

  def handle_errors(model_object = nil)
    yield
    if model_object&.changed? && model_object.present? && !model_object.valid?
      add_error(model_object.errors.full_messages)
      assign_data({ error: result.errors })
    end
  rescue StandardError => e
    add_error(e.message)
  end
end
