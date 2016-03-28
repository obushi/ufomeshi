ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }
  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "献立をアップロード" do
          form action: "/meals/upload", method: :post, enctype: "multipart/form-data" do |f|
            f.input name: "authenticity_token", type: :hidden, value: form_authenticity_token.to_s
            f.input name: "attachment", type: :file, accept: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            f.input type: :submit
          end
        end
        panel "アップロードの履歴" do
          table_for ConvertStatus.order('uploaded_at desc').limit(10) do
            column("ステータス")      {|file| status_tag(file.status) }
            column("アップロード日時") {|file| file.uploaded_at.strftime("%Y年%m月%d日 %H時%M分%S秒") }
            column("ファイル名")      {|file| file.file_name }
            column("開始日")         {|file| file.start_on }
            column("終了日")         {|file| file.end_on }
          end
        end
      end
      column do
        panel "Mealiについて" do
          render "about"
        end
      end
    end
  end
end
