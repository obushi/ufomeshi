class MenuController < ApplicationController

  @@StoreDir = "tmp/menu"

  def create
    file = params[:attachment]

    if file.present?
      Dir.mkdir( @@StoreDir ) unless Dir.exists?(@@StoreDir)
      FileUtils.mv( file.path, File.join(@@StoreDir, file.original_filename))

      begin
        MenuUtils.execute( File.join(@@StoreDir, file.original_filename) )
        redirect_to "/admin/dashboard", notice: "成功"
      rescue => e
        redirect_to "/admin/dashboard", alert: "エラー:#{e.message}"
      end

    else
      redirect_to "/admin/dashboard", alert: "献立ファイルを選択してください"
    end

  end

end
