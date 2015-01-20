class Url < ActiveRecord::Base

  def preview
    @preview unless @preview.nil?
    params = {}
    params[:url] = self.path
    params[:key] = 'a99fcfdb038a42ad955251bdc0660584'

    server = Net::HTTP.new("api.embed.ly")
    uri = URI("http://api.embed.ly/1/oembed")

    uri.query = URI.encode_www_form(params)
    response = server.get(uri)

    if response.is_a?(Net::HTTPSuccess)
      return @preview = JSON.parse(response.body)
    else
      return nil
    end
  end
end
