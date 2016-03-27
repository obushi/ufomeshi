class ConvertStatus < ApplicationRecord
    enum status: %w{success fail}
    enum method: %w{manual auto}
end
