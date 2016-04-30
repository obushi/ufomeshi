module Api
  module V1
    class MealsController < ApplicationController
      def index
      end

      def show
        @date = params[:date]
      end

      def search
        @q = params[:q]
      end
    end
  end
end
