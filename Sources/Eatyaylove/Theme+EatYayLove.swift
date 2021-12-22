//
//  Theme+EatYayLove.swift
//  
//
//  Created by Matthew Reed on 11/28/21.
//

import Foundation
import Publish
import Plot

extension Theme where Site == Eatyaylove {
    static var eatYayLove: Self {
        Theme(
            htmlFactory: EatYayLoveHTMLFactory(),
            resourcePaths: [
                "Resources/EatYayLoveTheme/bootstrap.min.css",
                "Resources/EatYayLoveTheme/styles.css"
            ]
        )
    }
    
    private struct EatYayLoveHTMLFactory: HTMLFactory {
        func makeIndexHTML(for index: Index,
                           context: PublishingContext<Eatyaylove>) throws -> HTML {
            HTML(
                .lang(context.site.language),
                .head(for: index, on: context.site, stylesheetPaths: ["/bootstrap.min.css", "/styles.css"]),
                .body {
                    EatYayLoveHeader(context: context, selectedSelectionID: nil)
                    Div {
                        H1(index.title)
                            .class("display-1")
                        Paragraph(context.site.description)
                            .class("description")
                        H2("Latest content")
                        ItemList(
                            items: context.allItems(
                                sortedBy: \.date,
                                order: .descending
                            ),
                            site: context.site
                        )
                    }
                    .class("container")
                    EatYayLoveFooter()
                }
            )
        }

        func makeSectionHTML(for section: Section<Eatyaylove>,
                             context: PublishingContext<Eatyaylove>) throws -> HTML {
            HTML(
                .lang(context.site.language),
                .head(for: section, on: context.site, stylesheetPaths: ["/bootstrap.min.css", "/styles.css"]),
                .body {
                    EatYayLoveHeader(context: context, selectedSelectionID: section.id)
                    Div {
                        H1(section.title)
                            .class("display-1")
                        ItemList(items: section.items, site: context.site)
                    }
                    .class("container")
                    EatYayLoveFooter()
                }
            )
        }

        func makeItemHTML(for item: Item<Eatyaylove>,
                          context: PublishingContext<Eatyaylove>) throws -> HTML {
            HTML(
                .lang(context.site.language),
                .head(for: item, on: context.site, stylesheetPaths: ["/bootstrap.min.css", "/styles.css"]),
                .body(
                    .class("item-page"),
                    .components {
                        EatYayLoveHeader(context: context, selectedSelectionID: item.sectionID)
                        Div {
                            Article {
                                if let url = item.metadata.imageUrl {
                                    Image(url)
                                }
                                Div(item.content.body).class("content")
                                Span("Tagged with: ")
                                ItemTagList(item: item, site: context.site)
                                if let ingredients = item.metadata.ingredients {
                                    H2("Ingredients")
                                    List(ingredients) { ingredient in
                                        ListItem(ingredient)
                                    }
                                }
                                if let steps = item.metadata.steps {
                                    H2("Steps")
                                    Paragraph(steps)
                                }
                            }
                        }
                        .class("container")
                        EatYayLoveFooter()
                    }
                )
            )
        }

        func makePageHTML(for page: Page,
                          context: PublishingContext<Eatyaylove>) throws -> HTML {
            HTML(
                .lang(context.site.language),
                .head(for: page, on: context.site, stylesheetPaths: ["/bootstrap.min.css", "/styles.css"]),
                .body {
                    EatYayLoveHeader(context: context, selectedSelectionID: nil)
                    Wrapper(page.body)
                    EatYayLoveFooter()
                }
            )
        }

        func makeTagListHTML(for page: TagListPage,
                             context: PublishingContext<Eatyaylove>) throws -> HTML? {
            HTML(
                .lang(context.site.language),
                .head(for: page, on: context.site, stylesheetPaths: ["/bootstrap.min.css", "/styles.css"]),
                .body {
                    EatYayLoveHeader(context: context, selectedSelectionID: nil)
                    Wrapper {
                        H1("Browse all tags")
                            .class("display-1")
                        List(page.tags.sorted()) { tag in
                            ListItem {
                                Link(tag.string,
                                     url: context.site.path(for: tag).absoluteString
                                )
                            }
                            .class("tag")
                        }
                        .class("all-tags")
                    }
                    EatYayLoveFooter()
                }
            )
        }

        func makeTagDetailsHTML(for page: TagDetailsPage,
                                context: PublishingContext<Eatyaylove>) throws -> HTML? {
            HTML(
                .lang(context.site.language),
                .head(for: page, on: context.site, stylesheetPaths: ["/bootstrap.min.css", "/styles.css"]),
                .body {
                    EatYayLoveHeader(context: context, selectedSelectionID: nil)
                    Wrapper {
                        H1 {
                            Text("Tagged with ")
                            Span(page.tag.string).class("tag")
                        }
                        .class("display-1")

                        Link("Browse all tags",
                            url: context.site.tagListPath.absoluteString
                        )
                        .class("browse-all")

                        ItemList(
                            items: context.items(
                                taggedWith: page.tag,
                                sortedBy: \.date,
                                order: .descending
                            ),
                            site: context.site
                        )
                    }
                    EatYayLoveFooter()
                }
            )
        }
    }

    private struct Wrapper: ComponentContainer {
        @ComponentBuilder var content: ContentProvider

        var body: Component {
            Div(content: content).class("wrapper")
        }
    }

    private struct EatYayLoveHeader<Eatyaylove: Website>: Component {
        var context: PublishingContext<Eatyaylove>
        var selectedSelectionID: Eatyaylove.SectionID?

        var body: Component {
            Header {
                Navigation {
                    Div {
                        Link(context.site.name, url: "/")
                            .class("navbar-brand")

                        if Eatyaylove.SectionID.allCases.count > 1 {
                            navigation
                        }
                    }
                    .class("container-fluid")
                }
                .class("navbar navbar-light bg-light")
            }
        }

        private var navigation: Component {
            
            List(Eatyaylove.SectionID.allCases) { sectionID in
                let section = context.sections[sectionID]
                
                return ListItem {
                    Link(section.title, url: section.path.absoluteString)
                        .class("nav-link")
                }
                .class("nav-item px-2")
            }
            .class("navbar-nav flex-row")
        }
    }

    private struct ItemList: Component {
        var items: [Item<Eatyaylove>]
        var site: Eatyaylove

        var body: Component {
            List(items) { item in
                Div {
                    if let url = item.metadata.imageUrl {
                        Image(url)
                            .class("card-img-top")
                    }
                    H1(Link(item.title, url: item.path.absoluteString))
                        .class("card-title")
                    Paragraph(item.description)
                        .class("card-text")
                }
                .class("card col")
            }
            .class("item-list row row-cols-2")
        }
    }

    private struct ItemTagList<Eatyaylove: Website>: Component {
        var item: Item<Eatyaylove>
        var site: Eatyaylove

        var body: Component {
            List(item.tags) { tag in
                Link(tag.string, url: site.path(for: tag).absoluteString)
            }
            .class("tag-list")
        }
    }

    private struct EatYayLoveFooter: Component {
        let socialMediaItems = [
            (title: "Instagram", url:"https://www.instagram.com/eatyaylove/"),
            (title: "Twitter", url:"https://www.twitter.com/eatyaylove/"),
            (title: "YouTube", url:"https://www.youtube.com/channel/UC1SmX-3N8xeYbsY18UmiGNw"),
        ]
        var body: Component {
            Footer {
                Paragraph {
                    List(socialMediaItems) { item in
                        ListItem {
                            Link(item.title, url: item.url)
                                .class("nav-link")
                        }
                        .class("nav-item")
                    }
                    .class("nav justify-content-center")
                }
                Paragraph {
                    Text("Generated using ")
                    Link("Publish", url: "https://github.com/johnsundell/publish")
                }
                Paragraph {
                    Link("RSS feed", url: "/feed.rss")
                }
            }
        }
    }

}

