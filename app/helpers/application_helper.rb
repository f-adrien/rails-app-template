module ApplicationHelper
  def disable_turbo_preview
    content_for(:metas) do
      sanitize("<meta name='turbo-cache-control' content='no-preview'>", tags: %w[meta], attributes: %w[name content])
    end
  end
end
