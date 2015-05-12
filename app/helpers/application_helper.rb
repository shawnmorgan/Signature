module ApplicationHelper

  def feedback_url
    desc = "Please add your feedback here.\n\n--- debugging info ---\n#{Base64.encode64 params.to_json}"
    query = { 'ticket[subject]' => 'Signature Feedback', 'ticket[description]' => desc }
    uri = URI::HTTPS.build(host: 'c3products.zendesk.com', path: '/anonymous_requests/new', query: query.to_query)

    uri.to_s
  end

end
