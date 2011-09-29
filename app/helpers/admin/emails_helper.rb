module Admin::EmailsHelper
  def subscribtion_title(s)
    user = s.user
    if user
      raw "&quot;#{user.name}&quot; &lt;#{user.email}&gt;"
    else
      s.address
    end
  end
end
