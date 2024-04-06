namespace :top_sliders do
  task delete_exceeded_deadline_for_publication: :environment do
    TopSlider.deadline_exceeded.find_each do |slider|
      slider.destroy
      p "delete #{slider.name}"
    end
  end
end
