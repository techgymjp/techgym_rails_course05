namespace :contact_status do
  desc "1週間以上過ぎた未対応のお問い合わせを対応済みにする"

  task expire: :environment do
    date_format = DateTime.current.strftime("%Y年%m月%d日 %H:%M:%S")
    p "[#{date_format}] contact_status:expireが実行されました。"

    changed_ids = []

    Contact.all.each do |contact|
      if contact.created_at < DateTime.current.ago(7.day) && contact.yet?
        changed_ids << contact.id
        contact.done!
      end
    end
    p "#{changed_ids.length}つのお問い合わせが変更されました。"
    if changed_ids.any?
      p "変更されたID: #{changed_ids.to_s}"
    end
  end

  def send_message(message)
    notifier = Slack::Notifier.new(
      Rails.application.credentials.slack_webhook_url,
      channel: '#general',
      username: 'Techgym Rails'
    )
    notifier.ping message
  end

  desc "Slackに通知サンプルを送信する"

  task send_message_sample: :environment do
    send_message('通知サンプル')
  end
end
