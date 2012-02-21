class ChangeBasicPlanToFree < ActiveRecord::Migration

  def up # 406
    change_column :shops, :plan, :string, default: 'free'
    Shop.all.each do |shop|
      shop.update_attributes! plan: 'free', deadline: nil if shop.plan == 'basic'
      if shop.plan = 'basic'
        shop.plan = 'free'
        shop.deadline = nil
        shop.save
      end
    end
  end

  def down
    change_column :shops, :plan, :string, default: 'basic'
    Shop.all.each do |shop|
      if shop.plan = 'free'
        shop.plan = 'basic'
        shop.deadline = 1.month.since
        shop.save
      end
    end
  end

end
