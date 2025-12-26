class Public::SearchesController < ApplicationController
	before_action :authenticate_user!

	def search
		if params[:content].blank?
      redirect_to root_path, alert: "検索キーワードを入力してください"
      return
    end
	  @model=params[:model]
	  @content=params[:content]
	  @method=params[:method]

    case @model
    when 'user'
      @records = User.where(deleted_at: nil)
                     .search_for(@content, @method)

    when 'group'
      @records = Group.where(deleted_at: nil)
                      .search_for(@content, @method)

    else # 'post'
      @records = Post.where(deleted_at: nil)
											.search_for(@content, @method)
    end
	end
end
