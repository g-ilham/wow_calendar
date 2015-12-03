module ExpectationHelper
  def expect_to_see(content)
    expect(page).to have_content content
  end

  def expect_to_see_no(content)
    expect(page).to_not have_content content
  end

  def expect_to_see_in_selector(content)
    expect(page).to have_selector(content)
  end

  def expect_to_see_no_in_selector(content)
    expect(page).to_not have_selector(content)
  end

  def to_eq_in_selector(selector, content)
    expect(selector).to eq(content)
  end

  def to_no_eq_in_selector(selector, content)
    expect(selector).to_not eq(content)
  end
end
