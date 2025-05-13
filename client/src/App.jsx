import "./App.css";
import { useAuth } from "./contexts/authentication";
import AuthenticatedApp from "./pages/AuthenticatedApp.jsx";
import axios from "axios";
import UnauthenticatedApp from "./pages/UnauthenticatedApp";

// Use environment variable for API URL
axios.defaults.baseURL = "https://mj-project.onrender.com/";

function App() {
  const auth = useAuth();
  return auth.isAuthenticated ? <AuthenticatedApp /> : <UnauthenticatedApp />;
}

export default App;
