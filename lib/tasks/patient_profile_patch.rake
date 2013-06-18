task :patient_profile_patch => :environment do
	if Rails.env == "development"
		Patient.all.each do |patient|
			unless patient.patient_profile
				patient.build_patient_profile(:uid => Time.now.usec)
				patient.save
			end
		end
	end
end
