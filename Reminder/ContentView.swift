//
//  ContentView.swift
//  Reminder
//
//  Created by 吉原博基 on 2023/07/10.
//

import SwiftUI
import MapKit

struct PinItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @State var name = ""
    @State var isShowMap = false
    
    // 現在地処理
    //    @ObservedObject  var manager = LocationManager()
    // ユーザートラッキングモードを追従モードにするための変数を定義
    //    @State  var trackingMode = MapUserTrackingMode.follow
    
    var body: some View {
        VStack(spacing: 16) {
            Button("Map"){
                isShowMap = true
            }
            .padding()
            .sheet(isPresented: $isShowMap) {
                MapView(latitude: 48.8583,
                        longitude: 2.2944,
                        test: name)
                .presentationDetents([.large])
            }
            TextField("Input Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            //現在地処理
            //            Map(coordinateRegion: $manager.region,
            //                showsUserLocation: true,
            // マップ上にユーザーの場所を表示するオプションをBool値で指定
            //                userTrackingMode: $trackingMode)
            // マップがユーザーの位置情報更新にどのように応答するかを決定
            //            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct MapView: View {
    @State private var region = MKCoordinateRegion() // 座標領域
    @State private var coordinate: CLLocationCoordinate2D? // 表示領域の中心位置
    var latitude: Double // 緯度
    var longitude: Double // 経度
    
    @State private var userTrackingMode: MapUserTrackingMode = .none
    
    let test: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text(test)
            
            Map(coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: [
                    PinItem(coordinate: .init(latitude: latitude, longitude: longitude))
                ],
                annotationContent: { item in
                MapMarker(coordinate: item.coordinate)
            })
            .onAppear {
                setRegion(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }
        }
    }
    
    // 引数で取得した緯度経度を使って動的に表示領域の中心位置と、縮尺を決める
    private func setRegion(coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(center: coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.0009, longitudeDelta: 0.0009)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

