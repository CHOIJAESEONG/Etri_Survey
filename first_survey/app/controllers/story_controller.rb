class StoryController < ApplicationController
  # for InvalidAuthenticityToken
  protect_from_forgery with: :exceptions

  def get_guide
    user = User.find(current_user.id)
    stories = user.Stories

  end

  def get_html
  end

  private
  def req_diquest
    request.GET 파싱 필요!!
    url = URI.parse("http://58.72.188.33:8080/lod/search.do?" + request.GET[:data] + "&type=json")
    req = Net::HTTP::Get.new(url.to_s)
    @res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
  end
end
