class CreateShortner
  include Interactor

  def call
    begin
      url = Shortner.create!(context.shortner_params.merge(short_url: generate_token(7)))
    rescue ActiveRecord::RecordNotUnique => error
      if error.message.include?('long_url')
        url = Shortner.find_by(context.shortner_params)
      else
        retry
      end
    rescue StandardError => error
      Rails.logger.info '-------Create Shorter Interactor------error----'
      Rails.logger.info "----Ошибка ===> #{error.inspect}---"
      raise error
    end

    context.url = url
  end

  private

  def generate_token(number)
    charset = Array('A'..'Z') + Array('a'..'z') + Array(0..9) + ['-', '_']
    Array.new(number) { charset.sample }.join
  end
end