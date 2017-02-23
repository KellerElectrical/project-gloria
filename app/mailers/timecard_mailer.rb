class TimecardMailer < ApplicationMailer
	def test(address)
		mail(to: address, subject: "it works holy praise kek")
	end
end
