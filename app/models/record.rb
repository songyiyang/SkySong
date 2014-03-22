class Record < ActiveRecord::Base
  belongs_to :user
  store_accessor :records
end
