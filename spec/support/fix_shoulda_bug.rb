# * Shoulda uses constants to store non-numerical (string)
# values when testing `validate_numericality_of`.
# * Rails 5 freezes values during validation/saving.
# * This freezes the value of the constant.
# * Postgres money fields call `sub!` on values which are
# passed in to be saved.
#
# The result of which is that by default `shoulda.validate_numericality_of`
# with rails 5 and postgres money fields will raise an error
# if validate_numericality_of is called on a number field after
# it has been called previously.
# If the money field is the first/only test of this type it
# will pass.

module Shoulda
  module Matchers
    module ActiveModel
      class AllowValueMatcher
        def self.new(*values)
          values &&= values.map { |value| value.is_a?(String) ? value.dup : value }
          super(*values)
        end
      end
    end
  end
end
