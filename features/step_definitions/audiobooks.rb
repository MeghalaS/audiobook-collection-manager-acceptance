#encoding: utf-8

Given /^some audiobooks in the collection$/ do
  # todo
end

When /^I visit the list of audiobooks$/ do
  visit 'http://localhost:8000/app/index.html'
end

Then /^I see the application name$/ do
  page.has_content?('Audiobook Collection Manager')
end

Then /^I see all audiobooks(?: again)?$/ do
  page.has_content?('Coraline')
  page.has_content?('Man In The Dark')
  page.has_content?('Siddharta')
end

When /^I search for "(.*?)"$/ do |search_term|
  fill_in('filter', :with => search_term)
  @matching_titles = ['Coraline']
  @not_matching_titles = ['Man In The Dark', 'Siddharta']
end

When /^I remove the filter$/ do
  fill_in('filter', :with => '')
  @matching_titles = @not_matching_titles = nil 
end

Then /^I only see titles matching the search term$/ do
  @matching_titles.each do |title|
    page.has_content?(title)
  end

  @not_matching_titles.each do |title|
    page.has_no_content?(title)
  end
end

When /^(?:I )?sort by "(.*?)"$/ do |sort_criterion|
  click_on(sort_criterion)
end

Then /^(?:I see )?"(.*?)" listed (first|second|third)$/ do |title, position|
  row = {'first' => '1', 'second' => '2', 'third' => '3'}[position]
  within_table('list_audiobooks') do
    within(:xpath, ".//tbody/tr[#{row}]") do
      page.should have_content title
    end
  end
end
