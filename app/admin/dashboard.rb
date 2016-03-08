ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    form action: "/menu", method: :post, enctype: "multipart/form-data" do |f|
      f.input name: "authenticity_token", type: :hidden, value: form_authenticity_token.to_s
      f.input name: "attachment", type: :file, accept: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      f.input type: :submit
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
