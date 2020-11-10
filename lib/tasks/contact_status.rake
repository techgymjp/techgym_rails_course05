namespace :contact_status do
  desc "1週間以上過ぎた未対応のお問い合わせを対応済みにする"

  task expire: :environment do
    Contact.all.each do |contact|
       if contact.created_at < DateTime.current.ago(7.day)
         contact.done!
       end
    end
  end
end
