class ConvertStatus < ApplicationRecord
    enum status: %w{ok warning}
end
