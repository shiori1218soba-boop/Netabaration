class Admin::SearchesController < Admin::BaseController

	def search
		if params[:content].blank?
      redirect_to admin_root_path, alert: "検索キーワードを入力してください"
      return
    end
	  @model=params[:model]
	  @content=params[:content]
	  @method=params[:method]

    case @model
    when 'user'
      @records = User.unscoped.search_for(@content, @method)

    when 'group'
      @records = Group.unscoped.search_for(@content, @method)

    else # 'post'
      @records = Post.unscoped.search_for(@content, @method)
    end
	end
end
