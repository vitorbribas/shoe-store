import { useState, useEffect } from 'react';
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
} from 'recharts';
import { MODELS } from '../constants/Models.tsx';
import { COLORS } from '../constants/Colors.tsx';
import WsEvent from '../../types/WsEvent.tsx';

type ChartProps = {
  latestMessage: WsEvent | null;
  store: string;
};

export function StoreChart(props: ChartProps) {
  const [modelsHistory, setModelsHistory] = useState([
    { ...MODELS, timestamp: new Date().toISOString() },
  ]);

  useEffect(() => {
    if (props.latestMessage && props.latestMessage.store === props.store) {
      const { model, inventory, timestamp } = props.latestMessage;

      setModelsHistory((prevHistory) => {
        const latestState = prevHistory[prevHistory.length - 1];
        const newState = {
          ...latestState,
          [model]: inventory,
          timestamp: timestamp,
        };

        const updatedHistory = [...prevHistory, newState];
        if (updatedHistory.length > 5) {
          updatedHistory.shift();
        }

        return updatedHistory;
      });
    }
  }, [props.latestMessage, props.store]);

  const latestState = modelsHistory[modelsHistory.length - 1];

  return (
    <div>
      <h2>Store: {props.store}</h2>
      <p>Lower models:</p>

      {Object.keys(latestState)
        .filter(
          (key) =>
            key !== 'timestamp' && latestState[key] > 0 && latestState[key] < 40
        )
        .map((model) => (
          <div>
            {model}: {latestState[model]}
          </div>
        ))}

      <LineChart width={1300} height={600} data={modelsHistory}>
        <CartesianGrid strokeDasharray="3 3" />
        <XAxis dataKey="timestamp" padding={{ left: 30, right: 30 }} />
        <YAxis />
        <Tooltip />
        <Legend />

        {Object.keys(MODELS).map((model) => {
          return (
            <Line
              type="monotone"
              dataKey={model}
              stroke={COLORS[model]}
              activeDot={{ r: 8 }}
            />
          );
        })}
      </LineChart>
    </div>
  );
}
