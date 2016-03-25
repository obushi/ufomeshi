class MealController < ApplicationController
  @@store_dir = Meali::Application.config.menu_root

  def upload
    excel_file = params[:attachment]
    if excel_file.present?
      Dir.mkdir(@@store_dir) unless Dir.exists?(@@store_dir)
      FileUtils.mv(excel_file.path, File.join(@@store_dir, excel_file.original_filename))
      begin
        xlsx_path = File.join(@@store_dir, excel_file.original_filename)
        redirect_back(fallback_location: "/admin/dashboard", notice: "アップロードしました")
      rescue => e
        redirect_back(fallback_location: "/admin/dashboard", alert: "エラー:#{e.message}")
      end

    else
      redirect_back(fallback_location: "/admin/dashboard", alert: "献立ファイルを選択してください")
    end
  end
end
