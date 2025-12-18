class Admin::SearchesController < Admin::BaseController

	def search
	  @model=params[:model]
	  @content=params[:content]
	  @method=params[:method]
	  if @model == 'user'
	    @users = User.search_for(@content,@method)
	  else
	    @posts = Post.search_for(@content,@method)
	  end
	end
end
