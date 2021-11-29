import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct Eatyaylove: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case recipes
        case about
        case contact
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://eatyaylove.com")!
    var name = "Eat Yay Love"
    var description = "A food and lifestyle blog"
    var language: Language { .english }
    var imagePath: Path? { "images/*.png" }
}

try Eatyaylove().publish(withTheme: .eatYayLove, deployedUsing: .gitHub("fattreed/fattreed.github.io", useSSH: true))
