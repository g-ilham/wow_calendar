module RemoveAnimation
  def remove_animation
    page.execute_script("$('.modal.fade').removeClass('fade')")
    page.execute_script("$('.js-landing-backdrop').remove()")
  end
end
