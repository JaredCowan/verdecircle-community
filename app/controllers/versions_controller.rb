class VersionsController < ApplicationController
  skip_authorization_check

  def revert
    @version = PaperTrail::Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    link_name = params[:redo] == "true" ? "undo" : "redo"
    link = view_context.link_to(link_name, revert_version_path(@version.next, :redo => !params[:redo]), class: "btn btn-warning", :method => :post)
    redirect_to :back, :notice => "Undid #{@version.event}. #{link}".html_safe
  end
end
