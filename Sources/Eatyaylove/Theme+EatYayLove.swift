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
            resourcePaths: ["Resources/EatYayLoveTheme/styles.css"]
        )
    }
}

private struct EatYayLoveHTMLFactory<EatYayLove: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<EatYayLove>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body {
                EatYayLoveHeader(context: context, selectedSelectionID: nil)
                Wrapper {
                    H1(index.title)
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
                EatYayLoveFooter()
            }
        )
    }

    func makeSectionHTML(for section: Section<EatYayLove>,
                         context: PublishingContext<EatYayLove>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body {
                EatYayLoveHeader(context: context, selectedSelectionID: section.id)
                Wrapper {
                    H1(section.title)
                    ItemList(items: section.items, site: context.site)
                }
                EatYayLoveFooter()
            }
        )
    }

    func makeItemHTML(for item: Item<EatYayLove>,
                      context: PublishingContext<EatYayLove>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .class("item-page"),
                .components {
                    EatYayLoveHeader(context: context, selectedSelectionID: item.sectionID)
                    Wrapper {
                        Article {
                            Div(item.content.body).class("content")
                            Span("Tagged with: ")
                            ItemTagList(item: item, site: context.site)
                        }
                    }
                    EatYayLoveFooter()
                }
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<EatYayLove>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                EatYayLoveHeader(context: context, selectedSelectionID: nil)
                Wrapper(page.body)
                EatYayLoveFooter()
            }
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<EatYayLove>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                EatYayLoveHeader(context: context, selectedSelectionID: nil)
                Wrapper {
                    H1("Browse all tags")
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
                            context: PublishingContext<EatYayLove>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
                EatYayLoveHeader(context: context, selectedSelectionID: nil)
                Wrapper {
                    H1 {
                        Text("Tagged with ")
                        Span(page.tag.string).class("tag")
                    }

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

private struct EatYayLoveHeader<EatYayLove: Website>: Component {
    var context: PublishingContext<EatYayLove>
    var selectedSelectionID: EatYayLove.SectionID?

    var body: Component {
        Header {
            Wrapper {
                Link(context.site.name, url: "/")
                    .class("site-name")

                if EatYayLove.SectionID.allCases.count > 1 {
                    navigation
                }
            }
        }
    }

    private var navigation: Component {
        Navigation {
            List(EatYayLove.SectionID.allCases) { sectionID in
                let section = context.sections[sectionID]

                return Link(section.title,
                    url: section.path.absoluteString
                )
                .class(sectionID == selectedSelectionID ? "selected" : "")
            }
        }
    }
}

private struct ItemList<EatYayLove: Website>: Component {
    var items: [Item<EatYayLove>]
    var site: EatYayLove

    var body: Component {
        List(items) { item in
            Article {
                H1(Link(item.title, url: item.path.absoluteString))
                ItemTagList(item: item, site: site)
                Paragraph(item.description)
            }
        }
        .class("item-list")
    }
}

private struct ItemTagList<EatYayLove: Website>: Component {
    var item: Item<EatYayLove>
    var site: EatYayLove

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
    ]
    var body: Component {
        Footer {
            Paragraph {
                List(socialMediaItems) { item in
                    Link(item.title, url: item.url)
                }
                .class("social")
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
