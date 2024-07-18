import './App.css';
import { StoreChart } from './components/StoreChart';
import { useState, useEffect } from 'react';
import { STORES } from './constants/Stores.tsx';

function App() {
  const [latestMessage, setLatestMessage] = useState(null);

  useEffect(() => {
    const ws = new WebSocket('ws://localhost:8080/');

    ws.onmessage = (event) => {
      const message = JSON.parse(event.data);
      setLatestMessage(message);
    };

    return () => ws.close();
  }, []);

  return (
    <div>
      <h1>Shoe Stores - Charts</h1>

      {STORES.map((store) => (
        <StoreChart key={store} store={store} latestMessage={latestMessage} />
      ))}
    </div>
  );
}

export default App;
