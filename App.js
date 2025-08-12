
import React, { useState } from 'react';
import { StyleSheet, Text, View, Image, TouchableOpacity, FlatList, Alert } from 'react-native';
import { Audio } from 'expo-av';
import letters from './assets/data/letters.json';
import animals from './assets/data/animals.json';

export default function App() {
  const [score, setScore] = useState(0);

  const playSound = async (uri) => {
    try {
      const { sound } = await Audio.Sound.createAsync(uri);
      await sound.playAsync();
      // unload after 2s
      setTimeout(()=>{ sound.unloadAsync(); }, 2000);
    } catch (e) { console.log(e); }
  };

  const renderLetter = ({item}) => (
    <View style={styles.card}>
      <Text style={styles.letter}>{item.char}</Text>
      <Image source={item.image} style={styles.image} />
      <Text style={styles.word}>{item.word}</Text>
      <TouchableOpacity style={styles.btn} onPress={()=>playSound(item.audio)}>
        <Text style={styles.btnText}>اسمع</Text>
      </TouchableOpacity>
    </View>
  );

  const renderAnimal = ({item}) => (
    <View style={styles.card}>
      <Image source={item.image} style={styles.image} />
      <Text style={styles.word}>{item.name_ar} - {item.name_en}</Text>
      <TouchableOpacity style={styles.btn} onPress={()=>playSound(item.audio)}>
        <Text style={styles.btnText}>اسمع</Text>
      </TouchableOpacity>
    </View>
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>برنامج أحمد عبدالعال</Text>
      </View>
      <Text style={styles.section}>الحروف</Text>
      <FlatList horizontal data={letters} keyExtractor={l=>l.id} renderItem={renderLetter} />
      <Text style={styles.section}>الحيوانات</Text>
      <FlatList horizontal data={animals} keyExtractor={a=>a.id} renderItem={renderAnimal} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex:1, backgroundColor:'#0F0B08', paddingTop:50 },
  header: { alignItems:'center', marginBottom:10 },
  title: { color:'#D4AF37', fontSize:24, fontWeight:'bold' },
  section: { color:'#D4AF37', fontSize:20, marginLeft:12, marginTop:12 },
  card: { backgroundColor:'#1E160F', margin:10, padding:12, borderRadius:12, alignItems:'center', width:220 },
  letter: { color:'#D4AF37', fontSize:72 },
  image: { width:140, height:140, marginVertical:8 },
  word: { color:'#D4AF37', fontSize:18 },
  btn: { backgroundColor:'#D4AF37', paddingHorizontal:16, paddingVertical:8, borderRadius:8, marginTop:8 },
  btnText: { color:'#0F0B08', fontWeight:'bold' }
});
