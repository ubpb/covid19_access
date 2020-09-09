class Account::ApplicationController < ApplicationController

  before_action :authenticate!

end
