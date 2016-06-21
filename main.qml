import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.XmlListModel 2.0

ApplicationWindow {
    id: root

    visible: true
    width: 800
    minimumWidth: label.implicitWidth
    height: 500
    minimumHeight: flickrTable.implicitHeight
    title: "volym3ad_application"

    toolBar: ToolBar {
        id: mainToolBar
        RowLayout {
            width: parent.width

            Label {
                text: "Flickr viewer."
                color: "grey"
                font.family: "Nokia Sans"
                font.pixelSize: 28
            }

            TextField {
                id: textSearch
                implicitWidth: 200
                placeholderText: "Search"
                anchors.right: parent.right
            }
        }
    }

    SplitView {

        anchors.fill: parent
        TableView {
            id: flickrTable
            frameVisible: false
            TableViewColumn {
                title: "Flickr"
                role: "title"
            }
            model: flickerModel
        }

        Image {
            id: image
            fillMode: Image.PreserveAspectFit
            source: flickerModel.get(flickrTable.currentRow).source.replace("_s", "_b")
        }
    }

    statusBar: StatusBar {
        RowLayout {
            width: parent.width
            Label {
                id: label
                text: image.source
                Layout.fillWidth: true
                elide: Text.ElideMiddle
            }

            ProgressBar {
                value: image.progress
            }
        }
    }

    XmlListModel {
        id: flickerModel
        source: "http://api.flickr.com/services/feeds/photos_public.gne?format=rss2&tags=" + textSearch.text
        query: "/rss/channel/item"
        namespaceDeclarations: "declare namespace media=\"http://search.yahoo.com/mrss/\";"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "date"; query: "pubDate/string()" }
        XmlRole { name: "source"; query: "media:thumbnail/@url/string()" }
        XmlRole { name: "credit"; query: "media:credit/string()" }
    }

}

