# frozen_string_literal: true

class UserDeSer < De::Ser::Ializer
  integer :id
  string :name
  string :username
  string :email
end
