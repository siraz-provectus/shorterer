class UrlsController < BaseController
  expose(:url) {Shortner.find_by!(short_url: params[:id])}

  def create
    self.url = CreateShortner.call(shortner_params: create_params).url
    render json: url.short_url
  end

  def show
    url.update!(visits_count: url.visits_count + 1)
    render json: url.long_url
  end

  def stats
    render json: url.visits_count
  end

  private

  def create_params
    params.permit(:long_url)
  end
end