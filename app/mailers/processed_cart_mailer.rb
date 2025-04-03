class ProcessedCartMailer < ActionMailer::Base
  default from: "inditest@rails.com"

  def processed(user_id, order_date)
    @user = User.find(user_id)
    @orders = Order.detail(@user, order_date)

    mail(to: @user.email, subject: "Order processed") do |format|
      format.text
    end
  end
end
