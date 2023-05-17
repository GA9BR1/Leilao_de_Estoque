class Answer < ApplicationRecord
  belongs_to :doubt
  belongs_to :user
  validates :content, :user_id, :doubt_id, presence: true

  after_create_commit :handle_answering_doubt
  after_create_commit :handle_broadcasting
  


  def handle_answering_doubt
    if user.admin
      doubt.answered = true
      doubt.save!
    else
      doubt.answered = false
      doubt.save!
    end
  end

  def handle_broadcasting
    if doubt.answers.count == 1
      broadcast_remove_to "batch", target: "no_answers_#{doubt.id}"
      broadcast_remove_to "not_answered", target: "no_answers_#{doubt.id}"
      broadcast_remove_to "batch_admin", target: "no_answers_#{doubt.id}"
    end
    broadcast_append_to "batch", target: "answers_#{doubt.id}"
    broadcast_append_to "not_answered", target: "answers_#{doubt.id}"
    broadcast_append_to "batch_admin", target: "answers_#{doubt.id}"
    if user.admin 
      broadcast_replace_to "not_answered", target: "toggle_answered_button_#{doubt.id}", partial: 'doubts/answered_checked', locals: {id: doubt.id}
    else
      broadcast_replace_to "not_answered", target: "toggle_answered_button_#{doubt.id}", partial: 'doubts/answered_unchecked', locals: {id: doubt.id}
    end
  end
  
end
