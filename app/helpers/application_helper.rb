module ApplicationHelper
  # Title Helper
  def title(*parts)
    unless parts.empty?
      content_for :title do
        (parts << "Ticketee").join(" - ")
      end
    end
  end

  # Admin only content block helper
  def admins_only
    yield if current_user.try(:admin?)
  end
end
