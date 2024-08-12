module PollutionTracker {
    struct CityPollution has key {
        city_name: string,
        pollution_level: u64,
        authority_email: string,
    }

    struct ImageReport has key {
        image: vector<u8>,
        city_name: string,
        description: string,
    }

    
    resource PollutionData {
    cities: map<string, CityPollution>,
    image_reports: map<u64, ImageReport>,
    next_image_id: u64,
    }





    public fun init() {
        let data <- PollutantData();
        move_to_sender(data);
    }

    public fun add_city_pollution(
        city_name: string,
        pollution_level: u64,
        authority_email: string,
    ) {
        let data = borrow_global_mut<PollutionData>(@0x1);
        let city = CityPollution {
            city_name,
            pollution_level,
            authority_email,
        };
        data.cities[city_name] = city;
    }

    public fun upload_image_report(
        image: vector<u8>,
        city_name: string,
        description: string,
    ) {
        let data = borrow_global_mut<PollutionData>(@0x1);
        let image_report = ImageReport {
            image,
            city_name,
            description,
        };
        let image_id = data.next_image_id;
        data.image_reports[image_id] = image_report;
        data.next_image_id += 1;
        send_email(image_report);
    }

    public fun get_highest_pollution_city(): (string, u64) {
        let data = borrow_global<PollutionData>(@0x1);
        let highest_pollution_city = data.cities.iter().max_by_key(|(_, city)| city.pollution_level);
        (highest_pollution_city.city_name, highest_pollution_city.pollution_level)
    }

    public fun get_city_authority_email(city_name: string): string {
        let data = borrow_global<PollutionData>(@0x1);
        data.cities[city_name].authority_email
    }

    fun send_email(image_report: ImageReport) {
        // TO DO: implement email sending logic using Aptos' Move SDK
        // For now, just print the email content
        print("Sending email to ");
        print(image_report.city_name);
        print(" authorities...");
        print("Image: ");
        print(image_report.image);
        print("Description: ");
        print(image_report.description);
    }
}