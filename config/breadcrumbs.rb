crumb :root do
  link "メルカリ", root_path
end

crumb :mypage do
  link "マイページ", users_path(current_user)
end

crumb :profile do
  link "プロフィール", profile_users_path
  parent :mypage
end

crumb :edit do
  link "本人情報の登録", edit_user_path
  parent :mypage
end

crumb :card do
  link "支払い方法", confirmation_card_path(current_user)
  parent :mypage
end

crumb :card_new do
  link "クレジットカード情報入力", new_card_path
  parent :card
end

crumb :logout do
  link "ログアウト", logout_users_path
end

crumb :itemshow do
  link "#{Item.find(params[:id]).name}", item_path
end


# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).