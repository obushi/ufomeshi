class MenuController < ApplicationController
  @@StoreDir = "tmp/menu"

  def create
    excel_file = params[:attachment]
    if excel_file.present?
      Dir.mkdir(@@StoreDir) unless Dir.exists?(@@StoreDir)
      FileUtils.mv(excel_file.path, File.join(@@StoreDir, excel_file.original_filename))
      begin
        MenuUtils::FileImporter.new(File.join(@@StoreDir, excel_file.original_filename)).to_csv
        redirect_back(fallback_location: "/admin/dashboard", notice: "成功")
      rescue => e
        redirect_back(fallback_location: "/admin/dashboard", alert: "エラー:#{e.message}")
      end

    else
      redirect_back(fallback_location: "/admin/dashboard", alert: "献立ファイルを選択してください")
    end
  end
end
