class ConvertStatus < ApplicationRecord
    enum status: %w{success fail}
end
