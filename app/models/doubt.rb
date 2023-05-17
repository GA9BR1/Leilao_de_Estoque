class Doubt < ApplicationRecord
  include ActiveModel::Dirty
  belongs_to :user
  belongs_to :batch
  has_many :answers
  validates :content, presence: true
  after_create_commit :handle_broadcasting_create
  after_update_commit :handle_broadcasting_update

  scope :visible, -> { where(visible: true) }
  scope :answered, -> { where(answered: true) }
  scope :not_answered, -> { where(answered: false) }
  

  def handle_broadcasting_create
    if self.batch.doubts.not_answered.count == 1
      broadcast_remove_to "not_answered", target: 'no_doubts_open'
    end
    if self.batch.doubts.count == 1
      broadcast_remove_to "batch", target: 'no_doubts'
      broadcast_remove_to "batch_admin", target: 'no_doubts'
    end
      broadcast_append_to "batch"
      broadcast_append_to "not_answered", target: 'not_answereds', partial: 'doubts/doubt_adm'
      broadcast_append_to "batch_admin", partial: 'doubts/doubt_adm'
  end

  def handle_broadcasting_update
    if previous_changes.include?(:answered)
      if answered == true
        broadcast_replace_to "not_answered", target: "toggle_answered_button_#{id}", partial: 'doubts/answered_checked', locals: {id: id}
        broadcast_replace_to "batch_admin", target: "toggle_answered_button_#{id}", partial: 'doubts/answered_checked', locals: {id: id}
      else
        broadcast_replace_to "not_answered", target: "toggle_answered_button_#{id}", partial: 'doubts/answered_unchecked', locals: {id: id}
        broadcast_replace_to "batch_admin", target: "toggle_answered_button_#{id}", partial: 'doubts/answered_unchecked', locals: {id: id}
      end
    end
    if previous_changes.include?(:visible)
      if visible == true
        broadcast_replace_to "batch_admin", target: "name_ocult_toggle_#{id}", partial: 'doubts/name_not_ocult', locals: {id: id}
        broadcast_replace_to "not_answered", target: "name_ocult_toggle_#{id}", partial: 'doubts/name_not_ocult', locals: {id: id}
        if Doubt.all.visible.count == 1
          broadcast_remove_to 'batch', target: 'no_doubts'
        end
        broadcast_append_to 'batch'
        broadcast_replace_to "not_answered", target: "toggle_visibility_button_#{id}", partial: 'doubts/visible', locals: {id: id}
        broadcast_replace_to "batch_admin", target: "toggle_visibility_button_#{id}", partial: 'doubts/visible', locals: {id: id}
      else
        broadcast_replace_to "batch_admin", target: "name_ocult_toggle_#{id}", partial: 'doubts/name_ocult', locals: {id: id}
        broadcast_replace_to "not_answered", target: "name_ocult_toggle_#{id}", partial: 'doubts/name_ocult', locals: {id: id}
        broadcast_remove_to "batch", target: "doubt_#{id}"
        if Doubt.all.visible.count == 0
          broadcast_append_to "batch", partial: 'doubts/no_doubts'
        end
        broadcast_replace_to "not_answered", target: "toggle_visibility_button_#{id}", partial: 'doubts/not_visible', locals: {id: id}
        broadcast_replace_to "batch_admin", target: "toggle_visibility_button_#{id}", partial: 'doubts/not_visible', locals: {id: id}
      end
    end
  end
end
