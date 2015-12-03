module RemoveAnimationModal
  def remove_animation_modal
    page.execute_script("$('.modal.fade').removeClass('fade')")
  end
end
