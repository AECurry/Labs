//Your task is to build a playlist manager Playground. Using a Song struct and Playlist class, the core of your app will be an array of playlists. The Playlist class should include a minimum of four properties name, author, songs, and currentlyPlaying, as well as the following functions:

struct Song: Equatable { // This protocol is fundamental for comparing values, enabling operations like filtering data,                       checking conditions, or verifying if objects in a collection are the same.
    var title: String
    var artist: String
    var duration: Double // duration in minutes
    
    var formattedDuration: String {
        let totalSeconds = Int(duration * 60)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds) //forces Swift to display in mm:ss format
    }
}

let classicChristmasSongList: [Song] = [
    Song(
        title: "White Christmas",
        artist: "Bing Crosby",
        duration: 3.00
    ),
    Song(
        title: "Have Yourself a Merry Little Christmas",
        artist: "Frank Sinatra",
        duration: 3.25
    ),
    Song(
        title: "The Christmas Song (Chestnuts Roasting on an Open Fire)",
        artist: "Nat King Cole",
        duration: 3.10
    ),
    Song(
        title: "Jingle Bell Rock",
        artist: "Bobby Helms",
        duration: 2.10
    ),
    Song(
        title: "Rockin’ Around the Christmas Tree",
        artist: "Brenda Lee",
        duration: 2.05
    ),
    Song(
        title: "It’s Beginning to Look a Lot Like Christmas",
        artist: "Michael Bublé",
        duration: 3.26
    ),
    Song(
        title: "Rudolph the Red-Nosed Reindeer",
        artist: "Gene Autry",
        duration: 3.05
    ),
    Song(
        title: "Sleigh Ride",
        artist: "The Ronettes",
        duration: 3.00
    ),
    Song(
        title: "Let It Snow! Let It Snow! Let It Snow!",
        artist: "Dean Martin",
        duration: 1.59
    ),
    Song(
        title: "Frosty the Snowman",
        artist: "Jimmy Durante",
        duration: 2.15
    ),
    Song(
        title: "Santa Claus Is Coming to Town",
        artist: "Jackson 5",
        duration: 2.25
    ),
    Song(
        title: "Winter Wonderland",
        artist: "Tony Bennett",
        duration: 2.20
    ),
]

class Playlist {
    var name: String
    var artist: String
    var songs: [Song] = []
    var currentlyPlayingSong: Int?
    
    init(name: String, artist: String) {
        self.name = name
        self.artist = artist
    }
    
    func sortByTitle() {
        songs.sort { $0.title < $1.title }
    }
    
    func sortByArtist() {
        songs.sort { $0.artist < $1.artist }
    }
    
    func sortByDuration() {
        songs.sort { $0.duration < $1.duration}
    }
    
    func move(song: Song, to index: Int) {
        if let currentIndex = songs.firstIndex(of: song),
           index >= 0 && index < songs.count {
            songs.remove(at: currentIndex)
            songs.insert(song, at: index)
        }
    }
    
    var count: Int {
        return songs.count
    }
    
    func allSongs() -> [Song] {
        return songs
    }
    
    func totalDuration() -> Double {
        var total = 0.0
        for song in songs {
            total += song.duration
        }
        return total
    }
    
    func currentSong() -> Song? {
        guard let index = currentlyPlayingSong else {
            return nil
        }
        return songs[index]
    }
    
    func play(at index: Int) -> Song? {
        if index >= 0 && index < songs.count {
            currentlyPlayingSong = index
            return songs[index]
        } else {
            return nil
        }
    }
}

let playlist = Playlist(name: "Christmas Favorites", artist: "Me")
playlist.songs = classicChristmasSongList

if let song = playlist.play(at:0) {
    print("Now playing: \(song.title) by \(song.artist)")
} else {
    print("Invalid index")
}

//When "playing" a song, you can simply output it to the console.

//Add sorting features that allow users to reorder the playlist by duration, song name, artist name, and any other properties you'd like.
//Also allow for custom rearranging of the playlist with a function along the lines of func move(song: Song, to index: Int).
