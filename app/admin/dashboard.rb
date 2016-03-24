ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }
  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "献立をアップロード" do
          form action: "/meal/upload", method: :post, enctype: "multipart/form-data" do |f|
            f.input name: "authenticity_token", type: :hidden, value: form_authenticity_token.to_s
            f.input name: "attachment", type: :file, accept: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            f.input type: :submit
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
