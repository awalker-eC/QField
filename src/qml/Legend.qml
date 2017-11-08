import QtQuick 2.0

import QtQuick.Controls 1.4 as Controls
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import org.qgis 1.0
import org.qfield 1.0
import QtQml.Models 2.2

import "js/style.js" as Style

TreeView {
  id: listView
  model: layerTree

  headerVisible: false

  QtObject {
    id: properties

    property var previousIndex
  }

  property VectorLayer currentLayer

  Controls.TableViewColumn {
    role: "display"
  }

  rowDelegate: Rectangle {
    height: layerTree.data(listView.__model.mapRowToModelIndex(styleData.row), LayerTreeModel.Type) === 'legend' ? 36 * dp : 48 * dp
    color: styleData.row !== undefined && layerTree.data(listView.__model.mapRowToModelIndex(styleData.row), LayerTreeModel.VectorLayer) === currentLayer ? "#999" : "#fff"
  }

  itemDelegate: Item {
    height: Math.max(16, label.implicitHeight)
    property int implicitWidth: label.implicitWidth + 20

    RowLayout {
      height: layerTree.data(listView.__model.mapRowToModelIndex(styleData.row), LayerTreeModel.Type) === 'legend' ? 36 * dp : 48 * dp
      Image {
        source: "image://legend/" + layerTree.data(styleData.index, LayerTreeModel.LegendImage)
        width: 24 * dp
        height: 24 * dp
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 1
      }

      Text {
        id: label
        horizontalAlignment: styleData.textAlignment
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 1
        elide: styleData.elideMode
        text: styleData.value !== undefined ? styleData.value : ""
        renderType: Settings.isMobile ? Text.QtRendering : Text.NativeRendering
      }
    }
  }

  /**
   * User clicked an item
   *
   * @param index : QModelIndex
   */
  onClicked: {
    var nodeType = layerTree.data(index, LayerTreeModel.Type)
    if (nodeType !== 'layer') {
      if (listView.isExpanded(index))
          listView.collapse(index)
      else
          listView.expand(index)
    }
    else
      currentLayer = layerTree.data(index, LayerTreeModel.VectorLayer)
  }

  onDoubleClicked: {
    if (listView.isExpanded(index))
        listView.collapse(index)
    else
        listView.expand(index)
  }
}
