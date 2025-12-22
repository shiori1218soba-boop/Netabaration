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
	  if @model == 'user'
	    @records = User.where(deleted_at: nil).search_for(@content,@method)
	  else
	    @records = Post.search_for(@content,@method)
	  end
	end
end
