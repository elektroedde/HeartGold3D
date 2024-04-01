import AVFoundation

struct Music {
    
    var audioPlayer: AVAudioPlayer?
    
    init() {
        guard let url = Bundle.main.url(forResource: "NBT", withExtension: "mp3") else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
        
//        audioPlayer?.play()
    }
}
